import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-post-photo"
export default class extends Controller {
  static targets = [ "fileInput", "form", "previews" ]

  connect() {
    console.log("new_post_photo_controller Stimulus controller is now connected");
    console.log("fileInput taget found", this.fileInputTarget)
    console.log("form taget found", this.formTarget)
    console.log("previews taget found", this.previewsTarget)
    this.fileInput = null;
  }

  disconnect() {
    console.log("I am disconnecing new_post_photo_controller");
  }

  // build hidden fileInput element, add to target, clear it, click it to
  // prompt file dialogue, add change listener to call handleFiles when file attached
  loadFileInput(event) {
    event.preventDefault();

    if (!this.fileInput) {
      this.fileInput = document.createElement('input');
      this.fileInput.type = 'file';
      this.fileInput.name = 'post[photos][]';
      this.fileInput.multiple = true;
      this.fileInput.style.display = 'none';
      this.fileInput.setAttribute('data-direct-upload-url',
        '/rails/active_storage/direct_uploads');
      this.fileInputTarget.appendChild(this.fileInput);
    
      this.fileInput.addEventListener('change', (event) => {
        this.handleFiles(this.fileInput.files);
      });
    }

    this.fileInput.value = "";
    this.fileInput.click();
  }

  // append a div to target to render each styled file within
  handleFiles(files) {
    this.previewsTarget.innerHTML = '';
    
    const fileList = Array.from(files);

    fileList.forEach(file => {
      const reader = new FileReader();
      
      reader.onload = (e) => {
        let imgContainer = document.createElement('div');
        imgContainer.classList.add('relative', 'inline-block');

        let img = document.createElement('img');
        img.src = e.target.result;
        img.classList.add('w-24', 'h-24', 'object-fit', 'rounded-sm', 'm-2');

        let removeButton = document.createElement('button');
        removeButton.textContent = 'x';
        removeButton.classList.add('remove-btn', 'absolute', 'top-2', 'right-2', 'bg-white', 'bg-opacity-70', 'text-black', 'p-1', 'text-sm', 'cursor-pointer', 'rounded-sm');
        removeButton.onclick = (e) => {
          e.preventDefault();
          e.stopPropagation();
          this.removeFile(file);
        }
        
        imgContainer.appendChild(img);
        imgContainer.appendChild(removeButton);
        this.previewsTarget.appendChild(imgContainer);
      };  
      
      reader.readAsDataURL(file);
    });
  }

  removeFile(fileToRemove) {
    this.fileInput.value = "";
    this.previewsTarget.innerHTML = '';
  }
}
