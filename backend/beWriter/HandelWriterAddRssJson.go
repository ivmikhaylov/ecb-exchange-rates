package beWriter

import (
	"log"
	"net/http"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func HandleWriterAddRssJson(w http.ResponseWriter, r *http.Request) {

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

	if par.CMD != "AddRss" {
		m = "Command is not recognized"
		beUtils.PutResponseJson(w, 400, m)
		return
	}

	m0 := "Exchange rates from RSS can't be added for the moment"

	// Put the RSS first
	e1 := putEcbRSSrates()
	if e1 != nil {
		log.Printf("putDayRates failed: %q", e1)
		beUtils.PutResponseJson(w, 500, m0)
		return
	}

	// Repair missing dates
	e2 := putMissingDates()
	if e2 != nil && e2 != errNoMissing {
		beUtils.PutResponseJson(w, 500, m0)
		return
	}

	m = "Done: exchange rates from RSS feed are in the db"
	beUtils.PutResponseJson(w, 200, m)

}
