import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["dropzone", "fileInput", "previewContainer", "previewTemplate", "fileCount"]

    connect() {
        this.setupDropzone()
    }

    setupDropzone() {
        const dropzone = this.dropzoneTarget

        dropzone.addEventListener('dragover', (e) => {
            e.preventDefault()
            dropzone.classList.add('border-blue-500', 'bg-blue-50')
        })

        dropzone.addEventListener('dragleave', (e) => {
            e.preventDefault()
            dropzone.classList.remove('border-blue-500', 'bg-blue-50')
        })

        dropzone.addEventListener('drop', (e) => {
            e.preventDefault()
            dropzone.classList.remove('border-blue-500', 'bg-blue-50')
            const files = e.dataTransfer.files
            if (files.length > 0) this.handleFiles(files)
        })

        dropzone.addEventListener('click', () => {
            this.fileInputTarget.click()
        })

        this.fileInputTarget.addEventListener('change', (e) => {
            this.handleFileSelect(e)
        })
    }

    handleFileSelect(event) {
        this.handleFiles(event.target.files)
    }

    handleFiles(files) {
        const validFiles = []
        for (let i = 0; i < files.length; i++) {
            const file = files[i]
            if (this.isValidFile(file)) {
                validFiles.push(file)
            } else {
                alert(`Файл "${file.name}" не поддерживается. Используйте изображения до 5MB.`)
            }
        }
        if (validFiles.length > 0) this.processFiles(validFiles)
        this.fileInputTarget.value = ''
    }

    isValidFile(file) {
        const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']
        const maxSize = 5 * 1024 * 1024
        return validTypes.includes(file.type) && file.size <= maxSize
    }

    processFiles(files) {
        const existingCount = this.previewContainerTarget.children.length
        const totalCount = existingCount + files.length
        if (totalCount > 10) {
            alert(`Максимум 10 фотографий. У вас уже ${existingCount} и пытаетесь добавить ${files.length}.`)
            return
        }
        files.forEach(file => this.addFilePreview(file))
        this.updateFileCounter()
    }

    addFilePreview(file) {
        const template = this.previewTemplateTarget.content.cloneNode(true)
        const preview = template.querySelector('.preview-item')
        const img = preview.querySelector('img')
        const fileName = preview.querySelector('.file-name')
        const fileSize = preview.querySelector('.file-size')
        fileName.textContent = this.truncateFileName(file.name, 20)
        fileSize.textContent = this.formatFileSize(file.size)
        const reader = new FileReader()
        reader.onload = (e) => img.src = e.target.result
        reader.readAsDataURL(file)
        const deleteBtn = preview.querySelector('.delete-btn')
        deleteBtn.addEventListener('click', (e) => {
            e.preventDefault()
            this.removeFilePreview(preview)
        })
        this.previewContainerTarget.appendChild(preview)
    }

    removeFilePreview(previewElement) {
        previewElement.remove()
        this.updateFileCounter()
    }

    updateFileCounter() {
        const count = this.previewContainerTarget.children.length
        this.fileCountTarget.textContent = `${count} файл${this.getRussianPlural(count)}`
    }

    truncateFileName(name, maxLength) {
        return name.length > maxLength ? name.substring(0, maxLength) + '...' : name
    }

    formatFileSize(bytes) {
        if (bytes === 0) return '0 Б'
        const k = 1024
        const sizes = ['Б', 'КБ', 'МБ', 'ГБ']
        const i = Math.floor(Math.log(bytes) / Math.log(k))
        return parseFloat((bytes / Math.pow(k, i)).toFixed(1)) + ' ' + sizes[i]
    }

    getRussianPlural(count) {
        if (count % 10 === 1 && count % 100 !== 11) return ''
        if ([2, 3, 4].includes(count % 10) && ![12, 13, 14].includes(count % 100)) return 'а'
        return 'ов'
    }
}