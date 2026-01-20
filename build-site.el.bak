(require 'org)
(require 'ox-publish)

(setq org-publish-project-alist
      `(("pages"
         :base-directory "roam/"
         :base-extension "org"
         :publishing-directory "public/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :html-head "<link rel=\"stylesheet\" href=\"/style.css\" type=\"text/css\"/>"
         ;; --- Header (Preamble) ---
         :html-preamble "<header>
                          <nav>
                            <span class='site-title'>Org Roam Notes</span>
                            <div class='nav-links'>
                              <a href='/index.html'>Home</a>
                              <a href='/about.html'>About</a>
                            </div>
                          </nav>
                        </header>"
         :html-postamble "<hr/><p class=\"footer\">Built with Emacs</p>"
         ;; --- Sitemap (File Structure) ---
         :auto-sitemap t
         :sitemap-filename "index.org"
         :sitemap-title "Knowledge Base"
         :sitemap-sort-files alphabetic
         :sitemap-format-entry (lambda (entry style project)
                                 (cond ((not (directory-name-p entry))
                                        (format "[[file:%s][%s]]" entry (org-publish-find-title entry project)))
                                       ((eq style 'tree) (file-name-nondirectory (directory-file-name entry)))
                                       (t entry)))
         :with-toc t)

        ("static"
         :base-directory "./"
         :base-extension "css\\|js\\|png\\|jpg"
         :publishing-directory "public/"
         :publishing-function org-publish-attachment)

        ("website" :components ("pages" "static"))))

(org-publish-all t)
