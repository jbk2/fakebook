import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="post-photo"
export default class extends Controller {
  static targets = [ "fileInput" ]

  connect() {
    console.log("post-photo Stimulus controller is connected. Here's this;", this.element)
    console.log("fileInput taget found", this.fileInputTarget)
  }

  // build hidden fileInput element, add to target, add listener to call handleFiles
  loadFileInput(event) {
    event.preventDefault();
    let fileInput = document.createElement('input');

    fileInput.type = 'file';
    fileInput.name = 'post[photos][]';
    fileInput.multiple = true;
    fileInput.style.display = 'none';

    this.fileInputTarget.appendChild(fileInput);
    
    fileInput.addEventListener('change', (event) => {
      this.handleFiles(fileInput.files);
    });
    
    fileInput.click();
  }

  // append a div to target to render each styled file within
  handleFiles(files) {
    const fileList = Array.from(files);

    let previewsContainer = document.createElement('div');
    previewsContainer.classList.add('previews', 'flex', 'flex-row', 'justify-center');
    this.fileInputTarget.after(previewsContainer); 

    previewsContainer.innerHTML = '';

    fileList.forEach(file => {
      const reader = new FileReader();
      
      reader.onload = (e) => {
        let img = document.createElement('img');
        img.src = e.target.result;
        img.classList.add('w-24', 'h-24', 'object-fit', 'rounded-sm', 'mx-1', 'object-cover');
        previewsContainer.appendChild(img);
      };
      
      reader.readAsDataURL(file);
    });
  }
}
