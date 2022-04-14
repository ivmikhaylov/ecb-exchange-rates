package beUtils

import (
	"log"
)

func CallDbCodeResp(u, s, q string) (c, h string, e error) {

	j, e1 := ReadDbJson(u, s, q)
	if e1 != nil {
		log.Printf("ReadDbJson failed: %q, %q, %q, %q", u, s, q, e1)
		return "500", msg500, e1
	}

	if len(j) < 1 {
		log.Printf("Empty json: %q, %q, %q", u, s, q)
		return "", msgEmpty, errEmpty
	}

	d := DbGetLongStatus{}

	e2 := ParseJson(j, &d)
	if e2 != nil {
		log.Printf("ParseJson failed: %q, %q, %q", j, d, e2)
		return "500", msg500, e2
	}

	c, n, e3 := GetRespVal(j)
	if e3 != nil {
		log.Printf("GetRespVal failed: %q, %q", j, e3)
		return "500", msg500, e3
	}

	return c, n, nil
}
