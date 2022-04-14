package beWriter

import (
	"net/http"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func HandleWriterHtml(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Content-Type", "text/html; charset=utf-8")

	m := "Provisioned for the Writer of the service"
	beUtils.PutResponseHtml(w, 200, m)

}
