package beReader

import (
	"fmt"
	"log"
	"net/http"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func HandleReaderActualJson(w http.ResponseWriter, r *http.Request) {

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

	if par.CMD != "ActualRates" {
		m = "Command is not recognized"
		beUtils.PutResponseJson(w, 400, m)
		return
	}

	nd := "FROM"
	d := par.FROM

	dp, m, e1 := beUtils.ParseUrlParDate(d, nd, dateTinyFmt, dateFmt)
	if e1 != nil {
		beUtils.PutResponseJson(w, 400, m)
		return
	}

	q := fmt.Sprintf("SELECT get_actual_rates_json('%s')", dp)

	j, e2 := getDbRatesJson(q)
	if e2 == errNoRates {
		m = fmt.Sprintf("No actual rates to list for %s", dp)
		beUtils.PutResponseJson(w, 404, m)
		return
	}

	m0 := "Actual rates can't be listed now"

	if e2 != nil {
		log.Printf("getDbRatesArray failed: %q", e2)
		beUtils.PutResponseJson(w, 500, m0)
		return
	}

	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	fmt.Fprint(w, j)

}
