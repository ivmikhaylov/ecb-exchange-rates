package beReader

import (
	"html/template"
	"log"
	"net/http"
)

func outHtmlTmplRates(w http.ResponseWriter, d DbManyRates,
	h string, m0 string) error {

	if len(d) < 1 {
		log.Printf("Empty Data Resp")
		http.Error(w, m0, http.StatusNoContent)
		return errEmpty
	}

	if len(h) < 1 {
		log.Printf("No title")
		h = dfltHtmlTitle
		// Minor issue
	}

	tm, e1 := template.New(h).Parse(HtmlTmplRates)
	if e1 != nil {
		log.Printf("template.New failed: %q", e1)
		http.Error(w, m0, http.StatusInternalServerError)
		return err500
	}

	e2 := tm.Execute(w, d)
	if e2 != nil {
		log.Printf("tm.Execute failed: %q", e2)
		http.Error(w, m0, http.StatusInternalServerError)
		return err500
	}

	return nil
}
