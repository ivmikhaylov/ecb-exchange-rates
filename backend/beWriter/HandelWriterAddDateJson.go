package beWriter

import (
	"fmt"
	"log"
	"net/http"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func HandleWriterAddDateJson(w http.ResponseWriter, r *http.Request) {

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

	if par.CMD != "AddDate" {
		m = "Command is not recognized"
		beUtils.PutResponseJson(w, 400, m)
		return
	}

	dp, m, e1 := beUtils.ParseUrlParDate(par.FROM, "FROM", dateTinyFmt, dateFmt)
	if e1 != nil {
		beUtils.PutResponseJson(w, 400, m)
		return
	}

	m0 := fmt.Sprintf("ECB exchange rates for %s can't be added for the moment", dp)

	// Put the RSS first
	e2 := putEcbRSSrates()
	if e2 != nil {
		log.Printf("putEcbRSSrates failed: %q", e2)
		beUtils.PutResponseJson(w, 500, m0)
		return
	}

	// Put rates of the requested day
	e3 := putEcbCRates(dp)
	if e3 != nil {
		log.Printf("putEcbCRates failed: %q", e3)
		beUtils.PutResponseJson(w, 500, m0)
		return
	}

	// Repair missing dates
	e4 := putMissingDates()
	if e4 != nil && e4 != errNoMissing {
		log.Printf("putMissingDates failed: %q", e4)
		beUtils.PutResponseJson(w, 500, m0)
		return
	}

	m = fmt.Sprintf("Done: exchange rates of %s are in the db. "+
		"Gaps in between this date and today are filled as well", dp)
	beUtils.PutResponseJson(w, 200, m)
}
