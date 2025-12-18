import multer from "multer";

export const upload = multer({
  storage: multer.memoryStorage(),
  // only pdf, ppt, pptx are allowed
    fileFilter: (req, file, cb) => {
        const allowedTypes = ["application/pdf", "application/vnd.ms-powerpoint", "application/vnd.openxmlformats-officedocument.presentationml.presentation"];
        if (allowedTypes.includes(file.mimetype)) {
            cb(null, true);
        } else {
            cb(new Error("Invalid file type. Only PDF and PPT files are allowed."));
        }
    },
  limits: {
    fileSize: 20 * 1024 * 1024, // 20MB
  },
});