import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="post-photo"
export default class extends Controller {
  static targets = [ "fileInput" ]

  connect() {
    console.log("post-photo Stimulus controller is connected. Here's this;", this.element)
    console.log("fileInput taget found", this.fileInputTarget)
  }

  // build filInput element, add to target, hide, add listener for file adding to call #handleFiles
  loadFileInput(event) {
    console.log('loadFileInput called');
    event.preventDefault();
    console.log('event is here;', event);
    
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

  // clear target div, create img elements for each file, append to target div
  handleFiles(files) {
    const fileList = Array.from(files);

    this.fileInputTarget.innerHTML = '';

    fileList.forEach(file => {
      const reader = new FileReader();
      
      reader.onload = (e) => {
        let img = document.createElement('img');
        img.src = e.target.result;
        img.style.width = '100px';
        img.style.height = '100px';
        img.style.objectFit = 'cover';
        img.style.marginRight = '5px';

        this.fileInputTarget.appendChild(img);
      };
      
      reader.readAsDataURL(file);
    });
  }
}
