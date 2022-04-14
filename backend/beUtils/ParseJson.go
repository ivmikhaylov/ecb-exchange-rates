package beUtils

import (
	"encoding/json"
	"log"
)

func ParseJson(j string, d interface{}) error {

	if len(j) < 1 {
		log.Printf("Empty Json")
		return errEmpty
	}

	e := json.Unmarshal([]byte(j), &d)
	if e != nil {
		log.Printf("json.Unmarshal failed: %q, %q, %q", j, d, e)
		return e
	}

	return nil
}
