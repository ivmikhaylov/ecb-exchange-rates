package beWriter

import (
	"fmt"
	"log"
	"net/http"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func HandleWriterGetMissingJson(w http.ResponseWriter, r *http.Request) {

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

	if par.CMD != "GetMissingDates" {
		m = "Command is not recognized"
		beUtils.PutResponseJson(w, 400, m)
		return
	}

	j, e1 := getMissingDatesJson()

	if e1 == errNoMissing {
		m = "All good, no missing dates found"
		beUtils.PutResponseJson(w, 404, m)
		return
	}

	m0 := "Missing dates can't be listed now"

	if e1 != nil {
		log.Printf("getMissingDate failed: %q", e1)
		beUtils.PutResponseJson(w, 500, m0)
		return
	}

	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	fmt.Fprint(w, j)
}
