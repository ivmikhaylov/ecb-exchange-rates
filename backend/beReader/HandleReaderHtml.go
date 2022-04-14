package beReader

import (
	"net/http"

	"github.com/ivmikhaylov/ecb-exchange-rates/tree/main/backend/beUtils"
)

func HandleReaderHtml(w http.ResponseWriter, r *http.Request) {

	m := "Provisioned for the Reader of the service"
	beUtils.PutResponseHtml(w, 200, m)

}
