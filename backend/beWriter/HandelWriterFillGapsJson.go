package beWriter

import (
	"log"
	"net/http"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func HandleWriterFeelGapsJson(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Content-Type", "application/json; charset=utf-8")

	var m string

	par, e0 := beUtils.ParseApiRequest(r.Body)
	if e0 != nil {
		m = "Wrong request"
		beUtils.PutResponseJson(w, 400, m)
		return
	}

	if par.USER != "Writer" {
		m = "Access is denied"
		beUtils.PutResponseJson(w, 401, m)
		return
	}

	if par.CMD != "FillGaps" {
		m = "Command is not recognized"
		beUtils.PutResponseJson(w, 400, m)
		return
	}

	e1 := putMissingDates()

	if e1 == errNoMissing {
		m = "All good, no gaps found"
		beUtils.PutResponseJson(w, 404, m)
		return
	}

	m0 := "Gaps can't be processed now"

	if e1 != nil {
		log.Printf("putMissingDates failed: %q", e1)
		beUtils.PutResponseJson(w, 500, m0)
		return
	}

	m = "Done: exchange rates for the gap dates were added"
	beUtils.PutResponseJson(w, 200, m)
}
