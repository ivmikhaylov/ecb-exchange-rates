package beAdmin

import (
	"net/http"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func HandleAdminHtml(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Content-Type", "text/html; charset=utf-8")

	m := "Provisioned for the Admin of the service"
	beUtils.PutResponseHtml(w, 200, m)
}
