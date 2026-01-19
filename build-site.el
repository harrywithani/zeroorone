;;; build-site.el --- Build documentation site

(require 'org)
(require 'ox-publish)

(setq org-publish-project-alist
      '(("zeroorone"
         :base-directory "roam/"
         :publishing-directory "public/"
         :publishing-function org-html-publish-to-html
         :with-toc t
         :section-numbers nil
         :html-head "<meta charset=\"utf-8\">
<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
<link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.classless.min.css\">
<style>
  body { max-width: 900px; margin: 0 auto; }
  code { color: #e83e8c; }
  pre { background: #f5f5f5; padding: 1em; border-radius: 0.5em; }
</style>"
         :html-postamble nil)))

(org-publish-all t)
(message "Site built!")
