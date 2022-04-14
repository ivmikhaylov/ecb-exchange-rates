package beWriter

import (
	"log"
	"net/http"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func HandleWriterAddRssHtml(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Content-Type", "text/html; charset=utf-8")

	m0 := "Exchange rates from RSS can't be added for the moment"

	// Put the RSS first
	e1 := putEcbRSSrates()
	if e1 != nil {
		log.Printf("putDayRates failed: %q", e1)
		beUtils.PutResponseHtml(w, 500, m0)
		return
	}

	// Repair missing dates
	e2 := putMissingDates()
	if e2 != nil && e2 != errNoMissing {
		log.Printf("putMissingDates failed: %q", e2)
		beUtils.PutResponseHtml(w, 500, m0)
		return
	}

	m := "Done: exchange rates from RSS feed are in the db"
	beUtils.PutResponseHtml(w, 200, m)

}
