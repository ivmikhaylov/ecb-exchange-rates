package beReader

import (
	"fmt"
	"log"
	"net/http"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func HandleReaderActualHtml(w http.ResponseWriter, r *http.Request) {

	nd := "date"

	d := r.URL.Query().Get(nd)

	dp, m, e1 := beUtils.ParseUrlParDate(d, nd, dateTinyFmt, dateFmt)
	if e1 != nil {
		beUtils.PutResponseHtml(w, 400, m)
		return
	}

	q := fmt.Sprintf("SELECT get_actual_rates_json('%s')", dp)

	dr, e2 := getDbRatesArray(q)
	if e2 == errNoRates {
		m = fmt.Sprintf("No actual rates to list for %s", dp)
		beUtils.PutResponseHtml(w, 404, m)
		return
	}

	m0 := "Actual rates can't be listed now"

	if e2 != nil {
		log.Printf("getDbRatesArray failed: %q", e2)
		beUtils.PutResponseHtml(w, 500, m0)
		return
	}

	h := fmt.Sprintf("Actual exchange rates for %s", dp)

	e3 := outHtmlTmplRates(w, dr, h, m0)
	if e3 != nil {
		beUtils.PutResponseHtml(w, 500, m)
		return
	}
}
