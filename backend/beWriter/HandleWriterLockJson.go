package beWriter

import (
	"fmt"
	"log"
	"net/http"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func HandleWriterLockJson(w http.ResponseWriter, r *http.Request) {

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

	if par.CMD != "LockService" {
		m = "Command is not recognized"
		beUtils.PutResponseJson(w, 400, m)
		return
	}

	q := "SELECT lock_service()"

	c, n, e := beUtils.CallDbCodeResp(usrName, pwdFile, q)

	if e == errEmpty {
		m = "No response received"
		beUtils.PutResponseJson(w, 444, m)
		return
	}

	if e != nil {
		log.Printf("CallDbCodeResp failed: %q, %q, %q, %q", usrName, pwdFile, q, e)
		m = "Response can't be provided for the moment"
		beUtils.PutResponseJson(w, 500, m)
		return
	}

	if c == "200" {
		m = "Successfully locked"
		beUtils.PutResponseJson(w, 200, m)
	} else {
		m = fmt.Sprintf("Error encountered: %q, %q", c, n)
		beUtils.PutResponseJson(w, 500, m)
	}
}
