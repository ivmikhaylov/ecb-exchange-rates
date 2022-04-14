package beUtils

import (
	"fmt"
	"html"
	"log"
	"net/http"
	"text/template"
)

func PutResponseHtml(w http.ResponseWriter, c int, m string) error {

	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	w.Header().Set("X-Content-Type-Options", "nosniff")
	w.WriteHeader(c)

	m0 := "Status responce can't be provided now."

	tm, e1 := template.New("Missing dates").Parse(HtmlTemplateStatus)
	if e1 != nil {
		log.Printf("template.New failed: %q", e1)
		fmt.Fprint(w, html.EscapeString(m0))
		return e1
	}

	e2 := tm.Execute(w, m)
	if e2 != nil {
		log.Printf("tm.Execute failed: %q", e2)
		fmt.Fprint(w, html.EscapeString(m0))
		return e2
	}

	return nil
}
