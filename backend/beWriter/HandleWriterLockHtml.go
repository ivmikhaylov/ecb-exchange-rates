package beWriter

import (
	"fmt"
	"log"
	"net/http"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func HandleWriterLockHtml(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Content-Type", "text/html; charset=utf-8")

	q := "SELECT lock_service()"

	c, n, e := beUtils.CallDbCodeResp(usrName, pwdFile, q)

	var m string

	if e == errEmpty {
		m = "No response received"
		beUtils.PutResponseHtml(w, 444, m)
		return
	}

	if e != nil {
		log.Printf("CallDbCodeResp failed: %q, %q, %q, %q", usrName, pwdFile, q, e)
		m = "Response can't be provided for the moment"
		beUtils.PutResponseHtml(w, 500, m)
		return
	}

	if c == "200" {
		m = "Successfully locked"
		beUtils.PutResponseHtml(w, 200, m)
	} else {
		m = fmt.Sprintf("Error encountered: %q, %q", c, n)
		beUtils.PutResponseHtml(w, 500, m)
	}
}
