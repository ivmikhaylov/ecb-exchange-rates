package beWriter

import (
	"fmt"
	"log"
	"net/http"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func HandleWriterAddDateHtml(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Content-Type", "text/html; charset=utf-8")

	nd := "date"

	d := r.URL.Query().Get(nd)

	dp, m, e1 := beUtils.ParseUrlParDate(d, nd, dateTinyFmt, dateFmt)
	if e1 != nil {
		beUtils.PutResponseHtml(w, 400, m)
		return
	}

	m0 := fmt.Sprintf("ECB exchange rates for %s can't be added for the moment", dp)

	// Put the RSS first
	e2 := putEcbRSSrates()
	if e2 != nil {
		log.Printf("putEcbRSSrates failed: %q", e2)
		beUtils.PutResponseHtml(w, 500, m0)
		return
	}

	// Put rates of the requested day
	e3 := putEcbCRates(dp)
	if e3 != nil {
		log.Printf("putEcbCRates failed: %q", e3)
		beUtils.PutResponseHtml(w, 500, m0)
		return
	}

	// Repair missing dates
	e4 := putMissingDates()
	if e4 != nil && e4 != errNoMissing {
		log.Printf("putMissingDates failed: %q", e4)
		beUtils.PutResponseHtml(w, 500, m0)
		return
	}

	m = fmt.Sprintf("Done: exchange rates of %s are in the db. "+
		"Gaps in between this date and today are filled as well", dp)
	beUtils.PutResponseHtml(w, 200, m)
}
