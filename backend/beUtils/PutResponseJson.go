package beUtils

import (
	"encoding/json"
	"log"
	"net/http"
)

func PutResponseJson(w http.ResponseWriter, c int, m string) error {

	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Header().Set("X-Content-Type-Options", "nosniff")
	w.WriteHeader(c)

	r := make(map[string]string)
	r["MESSAGE"] = m

	m0 := "Response can't be processed right now"

	jr, e := json.Marshal(r)
	if e != nil {
		log.Printf("json.Marshal failed: %q", e)
		PutResponseJson(w, 500, m0)
		return e
	}

	w.Write(jr)

	return nil
}
