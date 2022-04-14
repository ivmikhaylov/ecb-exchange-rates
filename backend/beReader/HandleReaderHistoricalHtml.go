package beReader

import (
	"fmt"
	"log"
	"net/http"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func HandleReaderHistoricalHtml(w http.ResponseWriter, r *http.Request) {

	nc := "cur"
	nf := "from"
	nt := "to"

	c := r.URL.Query().Get(nc)
	f := r.URL.Query().Get(nf)
	t := r.URL.Query().Get(nt)

	cp, m1, e1 := beUtils.ParseUrlParCur(c, nc)
	df, m2, e2 := beUtils.ParseUrlParDate(f, nf, dateTinyFmt, dateFmt)
	dt, m3, e3 := beUtils.ParseUrlParDate(t, nt, dateTinyFmt, dateFmt)

	if e1 != nil || e2 != nil || e3 != nil {
		m := fmt.Sprintln(m1, m2, m3)
		beUtils.PutResponseHtml(w, 400, m)
		return
	}

	q := fmt.Sprintf("SELECT get_historical_rates_json(%q, %q, %q)", cp, df, dt)

	dr, e4 := getDbRatesArray(q)
	if e4 == errNoRates {
		m := fmt.Sprintf("No historical rates to list for %s from %s to %s", cp, df, dt)
		beUtils.PutResponseHtml(w, 404, m)
		return
	}

	m0 := "Historical rates can't be listed now"

	if e4 != nil {
		log.Printf("getDbRatesArray failed: %q", e4)
		beUtils.PutResponseHtml(w, 500, m0)
		return
	}

	h := fmt.Sprintf("Historical exchange rates for %s ", cp) +
		fmt.Sprintf("from %s to %s", df, dt)

	e5 := outHtmlTmplRates(w, dr, h, m0)
	if e5 != nil {
		beUtils.PutResponseHtml(w, 500, m0)
		return
	}
}
