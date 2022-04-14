package beReader

import (
	"fmt"
	"log"
	"net/http"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func HandleReaderHistoricalJson(w http.ResponseWriter, r *http.Request) {

	var m string

	par, e0 := beUtils.ParseApiRequest(r.Body)
	if e0 != nil {
		m = "Wrong request"
		beUtils.PutResponseJson(w, 400, m)
		return
	}

	if par.USER != "Reader" {
		m = "Access is denied"
		beUtils.PutResponseJson(w, 401, m)
		return
	}

	if par.CMD != "HistoricalRates" {
		m = "Command is not recognized"
		beUtils.PutResponseJson(w, 400, m)
		return
	}

	cp, m1, e1 := beUtils.ParseUrlParCur(par.CUR, "CUR")
	df, m2, e2 := beUtils.ParseUrlParDate(par.FROM, "FROM", dateTinyFmt, dateFmt)
	dt, m3, e3 := beUtils.ParseUrlParDate(par.TO, "TO", dateTinyFmt, dateFmt)

	if e1 != nil || e2 != nil || e3 != nil {
		m := fmt.Sprintln(m1, m2, m3)
		beUtils.PutResponseJson(w, 400, m)
		return
	}

	q := fmt.Sprintf("SELECT get_historical_rates_json(%q, %q, %q)", cp, df, dt)

	j, e4 := getDbRatesJson(q)
	if e4 == errNoRates {
		m := fmt.Sprintf("No historical rates to list for %s from %s to %s", cp, df, dt)
		beUtils.PutResponseJson(w, 404, m)
		return
	}

	m0 := "Historical rates can't be listed now"

	if e4 != nil {
		log.Printf("getDbRatesJson failed: %q", e4)
		beUtils.PutResponseJson(w, 500, m0)
		return
	}

	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	fmt.Fprint(w, j)

}
