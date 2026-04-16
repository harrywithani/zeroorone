(require 'org)
(require 'ox-publish)
(require 'json)

(setq org-export-with-section-numbers nil)

(require 'package)
(package-initialize)

(unless (package-installed-p 'htmlize)
  (package-refresh-contents)
  (package-install 'htmlize))

;; --- The Content Search Indexer ---
(defun my/generate-search-index ()
  "Reads all org files and generates a full-text search.json index."
  (let ((files (directory-files-recursively "roam" "\\.org$"))
        (index nil))
    (dolist (file files)
      (with-temp-buffer
        (insert-file-contents file)
        (let* ((title (progn (goto-char (point-min))
                             (if (re-search-forward "^#\\+[tT][iI][tT][lL][eE]:\\s-*\\(.*\\)" nil t)
                                 (match-string 1)
                               (file-name-base file))))
               (tags (progn (goto-char (point-min))
                            (if (re-search-forward "^#\\+[fF][iI][lL][eE][tT][aA][gG][sS]:\\s-*\\(.*\\)" nil t)
                                (split-string (match-string 1) ":" t)
                              nil)))
               ;; Grabs the ENTIRE content of the note for full-text search
               (content (buffer-substring-no-properties (point-min) (point-max)))
               ;; Formats the URL correctly for GitLab and Localhost
               (rel-path (file-relative-name file "roam/"))
               (url (concat "/" (file-name-sans-extension rel-path) ".html")))
          (push (list (cons "title" title)
                      (cons "url" url)
                      (cons "tags" (or tags (vector)))
                      (cons "content" content))
                index))))
    (with-temp-file "docs/search.json"
      (insert (json-encode index)))))

;; --- Publish Config ---
(setq org-publish-project-alist
      `(("pages"
         :base-directory "roam/"
         :base-extension "org"
         :publishing-directory "docs"
         :recursive t
         :publishing-function org-html-publish-to-html
         :html-head "<link rel=\"stylesheet\" href=\"/zeroorone/style.css\" type=\"text/css\"/>
                     <script src=\"/zeroorone/theme.js\"></script>"

;; --- Header + The Hidden Sidebar ---
         :html-preamble "<header>
                          <nav class='breadcrumb'>
 			    <a href='/zeroorone/index.html'>Home</a>
                            <span class='breadcrumb-sep'>/</span>
                            <span class='breadcrumb-current'>%t</span>
                          </nav>
                          <div class='controls'>
                            <button class='sidebar-toggle' title='Search'>
                              <svg width='20' height='20' viewBox='0 0 24 24' fill='none' xmlns='http://www.w3.org/2000/svg'>
                                <path fill-rule='evenodd' clip-rule='evenodd' d='M18.319 14.4326C20.7628 11.2941 20.542 6.75347 17.6569 3.86829C14.5327 0.744098 9.46734 0.744098 6.34315 3.86829C3.21895 6.99249 3.21895 12.0578 6.34315 15.182C9.22833 18.0672 13.769 18.2879 16.9075 15.8442C16.921 15.8595 16.9351 15.8745 16.9497 15.8891L21.1924 20.1317C21.5829 20.5223 22.2161 20.5223 22.6066 20.1317C22.9971 19.7412 22.9971 19.1081 22.6066 18.7175L18.364 14.4749C18.3493 14.4603 18.3343 14.4462 18.319 14.4326ZM16.2426 5.28251C18.5858 7.62565 18.5858 11.4246 16.2426 13.7678C13.8995 16.1109 10.1005 16.1109 7.75736 13.7678C5.41421 11.4246 5.41421 7.62565 7.75736 5.28251C10.1005 2.93936 13.8995 2.93936 16.2426 5.28251Z' fill='currentColor'/>
                              </svg>
                            </button>

                            <button class='theme-toggle' title='Toggle Theme'>
                              <svg width='20' height='20' viewBox='0 0 24 24' fill='none' xmlns='http://www.w3.org/2000/svg'>
                                <path d='M12 16C14.2091 16 16 14.2091 16 12C16 9.79086 14.2091 8 12 8V16Z' fill='currentColor'/>
                                <path fill-rule='evenodd' clip-rule='evenodd' d='M12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2ZM12 4V8C9.79086 8 8 9.79086 8 12C8 14.2091 9.79086 16 12 16V20C16.4183 20 20 16.4183 20 12C20 7.58172 16.4183 4 12 4Z' fill='currentColor'/>
                              </svg>
                            </button>

                            <button class='toc-toggle' title='Table of Contents'>
                              <svg width='20' height='20' viewBox='0 0 24 24' fill='none' xmlns='http://www.w3.org/2000/svg'>
                                <path d='M2 6C2 5.44772 2.44772 5 3 5H21C21.5523 5 22 5.44772 22 6C22 6.55228 21.5523 7 21 7H3C2.44772 7 2 6.55228 2 6Z' fill='currentColor'/>
                                <path d='M2 12.0322C2 11.4799 2.44772 11.0322 3 11.0322H21C21.5523 11.0322 22 11.4799 22 12.0322C22 12.5845 21.5523 13.0322 21 13.0322H3C2.44772 13.0322 2 12.5845 2 12.0322Z' fill='currentColor'/>
                                <path d='M3 17.0645C2.44772 17.0645 2 17.5122 2 18.0645C2 18.6167 2.44772 19.0645 3 19.0645H21C21.5523 19.0645 22 18.6167 22 18.0645C22 17.5122 21.5523 17.0645 21 17.0645H3Z' fill='currentColor'/>
                              </svg>
                            </button>
                          </div>
                        </header>

                        <aside id='left-sidebar'>
                          <div class='sidebar-header'>
                            <h3>Search & Tags</h3>
                            <button class='sidebar-close' title='Close'>
                              <svg width='20' height='20' viewBox='0 0 15 15' fill='none' xmlns='http://www.w3.org/2000/svg'>
                                <path fill-rule='evenodd' clip-rule='evenodd' d='M11.7816 4.03157C12.0062 3.80702 12.0062 3.44295 11.7816 3.2184C11.5571 2.99385 11.193 2.99385 10.9685 3.2184L7.50005 6.68682L4.03164 3.2184C3.80708 2.99385 3.44301 2.99385 3.21846 3.2184C2.99391 3.44295 2.99391 3.80702 3.21846 4.03157L6.68688 7.49999L3.21846 10.9684C2.99391 11.193 2.99391 11.557 3.21846 11.7816C3.44301 12.0061 3.80708 12.0061 4.03164 11.7816L7.50005 8.31316L10.9685 11.7816C11.193 12.0061 11.5571 12.0061 11.7816 11.7816C12.0062 11.557 12.0062 11.193 11.7816 10.9684L8.31322 7.49999L11.7816 4.03157Z' fill='currentColor'/>
                              </svg>
                            </button>
                          </div>
                          <div class='search-container'>
                            <input type='text' id='sidebar-search' placeholder='Search full content or #tags...' autocomplete='off'>
                          </div>
                          <div id='sidebar-tags' class='tag-cloud'></div>
                          <ul id='sidebar-results'></ul>
                        </aside>"
         :html-postamble "<p class=\"footer\">Built with Emacs</p>
                         <script src=\"https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js\"></script>
                          <script>
                          window.addEventListener(\"DOMContentLoaded\", () => {
                            document.querySelectorAll(\"pre.src\").forEach(pre => {
                              const classes = Array.from(pre.classList);
                              const langClass = classes.find(c => c.startsWith(\"src-\"));
                              if (!langClass) return;

                              const lang = langClass.replace(\"src-\", \"\");

                              const code = document.createElement(\"code\");
                              code.className = \"language-\" + lang;
                              code.textContent = pre.textContent;

                              pre.innerHTML = \"\";
                              pre.appendChild(code);
                            });

                            hljs.highlightAll();
                          });
                          </script>"
         :auto-sitemap t
         :sitemap-filename "index.org"
         :sitemap-title "Knowledge Base"
         :sitemap-sort-files alphabetically
         :with-toc t)

        ("static"
         :base-directory "./"
         :base-extension "css\\|js\\|png\\|jpg"
         :publishing-directory "docs"
         :publishing-function org-publish-attachment)

        ("website" :components ("pages" "static"))))

(org-publish-all t)
(my/generate-search-index) ;; This actually creates the search.json
