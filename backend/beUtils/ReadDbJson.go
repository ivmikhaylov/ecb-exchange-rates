package beUtils

import (
	"database/sql"
	"fmt"
	"log"
	"strconv"
)

func ReadDbJson(u, fn, q string) (j string, e error) {

	db, e1 := connectDb(u, fn)
	if e1 != nil {
		log.Printf("ConnectDb failed: %q, %q, %q", u, fn, e1)
		return "", e1
	}
	defer db.Close()

	qq := fmt.Sprintf("%q", q)
	uq, e2 := strconv.Unquote(qq)
	if e2 != nil {
		log.Printf("Query Unquote failed: %q, %q", qq, e2)
		return "", e2
	}

	r := db.QueryRow(uq)

	e3 := r.Scan(&j)

	if e3 == sql.ErrNoRows {
		log.Printf("Empty response from db: %q", e3)
		return "", e3
	}

	if e3 != nil {
		log.Printf("row.Scan failed: %q", e3)
		return "", e3
	}

	return j, nil
}
