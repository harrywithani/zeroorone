;;; build-site.el --- Build documentation site with navigation

(require 'org)
(require 'ox-publish)
(require 'ox-html)

;; Create output directory
(make-directory "public" t)

;; Custom HTML template with navigation
(setq org-html-template
      "<!DOCTYPE html>
<html lang=\"en\">
<head>
  <meta charset=\"UTF-8\">
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
  <title>%t</title>
  <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.classless.min.css\">
  <style>
    * { margin: 0; padding: 0; }
    body {
      display: grid;
      grid-template-columns: 250px 1fr;
      min-height: 100vh;
      background: var(--form-element-background-color);
    }
    nav {
      background: var(--card-background-color);
      padding: 2rem 1rem;
      border-right: 1px solid var(--border-color);
      position: sticky;
      top: 0;
      height: 100vh;
      overflow-y: auto;
    }
    nav h3 {
      margin-top: 1.5rem;
      margin-bottom: 0.5rem;
      font-size: 0.9rem;
      text-transform: uppercase;
      opacity: 0.7;
    }
    nav a {
      display: block;
      padding: 0.5rem 0.75rem;
      text-decoration: none;
      border-radius: 0.25rem;
      margin-bottom: 0.25rem;
      font-size: 0.95rem;
    }
    nav a:hover {
      background: var(--form-element-focus-border-color);
      opacity: 0.8;
    }
    main {
      padding: 2rem;
      max-width: 900px;
      margin: 0 auto;
      width: 100%;
    }
    main h1 {
      margin-bottom: 1rem;
      color: var(--color);
    }
    code {
      color: #e83e8c;
      background: var(--form-element-background-color);
      padding: 0.2em 0.4em;
      border-radius: 0.25em;
    }
    pre {
      background: var(--form-element-background-color);
      border: 1px solid var(--border-color);
      padding: 1em;
      border-radius: 0.5em;
      overflow-x: auto;
    }
    @media (max-width: 768px) {
      body { grid-template-columns: 1fr; }
      nav { position: relative; height: auto; border-right: none; border-bottom: 1px solid var(--border-color); }
      main { padding: 1rem; }
    }
  </style>
</head>
<body>
  <nav id=\"sidebar\">
    <h3>Navigation</h3>
    <a href=\"index.html\">Home</a>
    <h3>Pages</h3>
    <!-- Links will be inserted here -->
  </nav>
  <main>
    %c
  </main>
</body>
</html>")

;; Function to generate navigation links
(defun my/generate-nav-links ()
  "Generate navigation links from all org files"
  (let ((files (directory-files "roam" nil "\\.org$")))
    (mapconcat
     (lambda (file)
       (let ((title (with-temp-buffer
                      (insert-file-contents (concat "roam/" file))
                      (when (re-search-forward "^#+title: \\(.+\\)" nil t)
                        (match-string 1))))
             (html-file (concat (file-name-sans-extension file) ".html")))
         (if title
             (format "    <a href=\"%s\">%s</a>\n" html-file title)
           (format "    <a href=\"%s\">%s</a>\n" html-file (file-name-sans-extension file)))))
     (sort files #'string<)
     "")))

;; Inject navigation into template
(setq org-html-template
      (replace-regexp-in-string
       "    <!-- Links will be inserted here -->"
       (my/generate-nav-links)
       org-html-template))

;; Publish configuration
(setq org-publish-project-alist
      '(("zeroorone"
         :base-directory "roam/"
         :publishing-directory "public/"
         :publishing-function org-html-publish-to-html
         :with-toc t
         :toc-depth 3
         :section-numbers nil
         :recursive t
         :html-head-extra ""
         :html-postamble nil
         :html-preamble nil)))

(org-publish-all t)
(message "Site built successfully with navigation!")
