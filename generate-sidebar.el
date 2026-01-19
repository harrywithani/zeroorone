;;; generate-sidebar.el --- Generate sidebar navigation HTML

(require 'json)

;; Scan roam directory and create file tree
(defun my/generate-file-tree ()
  "Generate HTML file tree from roam/ directory"
  (let ((files (directory-files "roam" nil "\\.org$"))
        (sidebar ""))

    (setq sidebar "<div class=\"file-tree\">\n")

    (dolist (file (sort files #'string<))
      (let* ((filepath (concat "roam/" file))
             (title (with-temp-buffer
                      (insert-file-contents filepath)
                      (if (re-search-forward "^#+title: \\(.+\\)" nil t)
                          (match-string 1)
                        (file-name-sans-extension file))))
             (htmlfile (concat (file-name-sans-extension file) ".html")))
        (setq sidebar (concat sidebar
                              (format "  <a href=\"%s\">📄 %s</a>\n" htmlfile title)))))

    (setq sidebar (concat sidebar "</div>\n"))
    sidebar))

;; Generate sidebar HTML file
(defun my/create-sidebar-html ()
  "Create sidebar.html with navigation"
  (let ((sidebar-content
         (concat "<nav id=\"sidebar\">\n"
                 "  <h2>My Notes</h2>\n"
                 (my/generate-file-tree)
                 "</nav>\n")))

    (with-temp-file "public/sidebar.html"
      (insert sidebar-content))

    (message "✓ Sidebar generated!")))

(my/create-sidebar-html)
