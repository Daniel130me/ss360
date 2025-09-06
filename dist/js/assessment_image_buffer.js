// Client-side image buffer for assessment images
// This module should be included before examination.js

window.AssessmentImageBuffer = {
    images: new Map(), // key: blobUrl, value: File

    addImage: function(file) {
        const blobUrl = URL.createObjectURL(file);
        this.images.set(blobUrl, file);
        return blobUrl;
    },

    getImages: function() {
        return Array.from(this.images.entries()); // [ [blobUrl, File], ... ]
    },

    getFileByBlobUrl: function(blobUrl) {
        return this.images.get(blobUrl);
    },

    clear: function() {
        this.images.forEach((file, blobUrl) => URL.revokeObjectURL(blobUrl));
        this.images.clear();
    },

    removeUnused: function(usedBlobUrls) {
        // Remove any blobUrls not in usedBlobUrls
        for (let [blobUrl] of this.images) {
            if (!usedBlobUrls.includes(blobUrl)) {
                URL.revokeObjectURL(blobUrl);
                this.images.delete(blobUrl);
            }
        }
    }
};
