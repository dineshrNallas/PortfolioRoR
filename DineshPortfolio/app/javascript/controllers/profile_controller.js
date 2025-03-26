import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "input", "editButton", "saveButton", "fileUpload", "fileInput", "base64Input"]
  token = document.querySelector('meta[name="csrf-token"]').content

  connect() {
    
  }
  
  edit() {
    this.inputTargets.forEach(el => el.disabled = false)
    this.editButtonTarget.style.display = 'none'
    this.saveButtonTarget.style.display = 'inline'
    this.fileUploadTarget.style.display = 'block'
  }

  handleFileSelect(event) {
    const file = event.target.files[0]
    if (!file) return
    
    // Check if file is an image
    if (!file.type.match('image.*')) {
      alert('Please select an image file')
      return
    }
    
    const reader = new FileReader()
    reader.onload = (e) => {
      const img = new Image()
      img.onload = () => {
        // Create canvas for resizing
        const canvas = document.createElement('canvas')
        let width = img.width
        let height = img.height
        
        // Calculate new dimensions while maintaining aspect ratio
        const MAX_WIDTH = 600  // Reduced from 800
        const MAX_HEIGHT = 600 // Reduced from 800
        
        if (width > height) {
          if (width > MAX_WIDTH) {
            height *= MAX_WIDTH / width
            width = MAX_WIDTH
          }
        } else {
          if (height > MAX_HEIGHT) {
            width *= MAX_HEIGHT / height
            height = MAX_HEIGHT
          }
        }
        
        // Resize image
        canvas.width = width
        canvas.height = height
        const ctx = canvas.getContext('2d')
        ctx.drawImage(img, 0, 0, width, height)
        
        // Convert to base64 with reduced quality
        let quality = 0.5  // Reduced from 0.7
        let resizedBase64 = canvas.toDataURL('image/jpeg', quality)
        
        // If still too large, reduce quality further
        if (resizedBase64.length > 200000) { // ~200KB
          quality = 0.3
          resizedBase64 = canvas.toDataURL('image/jpeg', quality)
        }
        
        // Store the base64 data in the hidden input
        this.base64InputTarget.value = resizedBase64
        
        // Update the image preview
        const imagePreview = document.querySelector('.card-image img')
        if (imagePreview) {
          imagePreview.src = resizedBase64
        }
      }
      img.src = e.target.result
    }
    reader.readAsDataURL(file)
  }

  save(event) {
    event.preventDefault()
    const formData = new FormData(this.formTarget)
    
    // Ensure the base64 data is included if a file was selected
    if (this.fileInputTarget.files.length > 0) {
      formData.set('profile[image_url]', this.base64InputTarget.value)
    }
    
    // Show loading indicator
    this.saveButtonTarget.textContent = 'Saving...'
    this.saveButtonTarget.disabled = true
    
    fetch(this.formTarget.action, {
      method: 'PATCH',
      headers: { 
        'X-CSRF-Token': this.token,
        'Accept': 'application/json'
      },
      body: formData
    })
    .then(response => {
      // Reset button state
      this.saveButtonTarget.textContent = 'Save'
      this.saveButtonTarget.disabled = false
      
      if (!response.ok) {
        return response.json()
          .then(data => {
            throw new Error(data.errors ? data.errors.join(", ") : `Server error! Status: ${response.status}`);
          })
          .catch(e => {
            if (e instanceof SyntaxError) {
              throw new Error(`Server error! Status: ${response.status}`);
            }
            throw e;
          });
      }
      return response.json();
    })
    .then(data => {
      if (data.success) {
        alert("Profile updated!")
        this.inputTargets.forEach(el => el.disabled = true)
        this.editButtonTarget.style.display = 'inline'
        this.saveButtonTarget.style.display = 'none'
        this.fileUploadTarget.style.display = 'none'
      } else {
        alert("Error: " + data.errors.join(", "))
      }
    })
    .catch(error => {
      console.error('Error:', error)
      alert("An error occurred while saving the profile: " + error.message)
    })
  }
}
