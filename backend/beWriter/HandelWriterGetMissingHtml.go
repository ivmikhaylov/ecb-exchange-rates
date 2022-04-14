package beWriter

import (
	"log"
	"net/http"
	"text/template"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func HandleWriterGetMissingHtml(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Content-Type", "text/html; charset=utf-8")

	var m string

	d, e1 := getMissingDatesArray()

	if e1 == errNoMissing {
		m = "All good, no missing dates found"
		beUtils.PutResponseHtml(w, 404, m)
		return
	}

	m0 := "Missing dates can't be listed now"

	if e1 != nil {
		log.Printf("getMissingDate failed: %q", e1)
		beUtils.PutResponseHtml(w, 500, m0)
		return
	}

	tm, e2 := template.New("Missing dates").Parse(HtmlTmplMissing)
	if e2 != nil {
		log.Printf("template.New failed: %q", e2)
		beUtils.PutResponseHtml(w, 500, m0)
		return
	}

	errExec := tm.Execute(w, d)
	if errExec != nil {
		log.Printf("tmplMissing.Execute failed: %q", e2)
		beUtils.PutResponseHtml(w, 500, m0)
		return
	}
}
