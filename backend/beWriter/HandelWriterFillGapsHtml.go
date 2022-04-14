package beWriter

import (
	"log"
	"net/http"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func HandleWriterFeelGapsHtml(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Content-Type", "text/html; charset=utf-8")

	var m string

	e1 := putMissingDates()

	if e1 == errNoMissing {
		m = "All good, no gaps found"
		beUtils.PutResponseHtml(w, 404, m)
		return
	}

	m0 := "Gaps can't be processed now"

	if e1 != nil {
		log.Printf("putMissingDates failed: %q", e1)
		beUtils.PutResponseHtml(w, 500, m0)
		return
	}

	m = "Done: exchange rates for the gap dates were added"
	beUtils.PutResponseHtml(w, 200, m)
}
