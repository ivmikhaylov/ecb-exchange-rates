package beUtils

import (
	"database/sql"
	"fmt"
	"log"
)

func connectDb(u, f string) (*sql.DB, error) {

	fn := fmt.Sprintf("%s%s", pwdPath, f)

	s, e1 := getPwdFromFile(fn)
	if e1 != nil {
		log.Printf("Reading password from file %q failed: %q", fn, e1)
		return nil, e1
	}

	a := setAccessDbStr(u, string(s), dbPort, dbName)
	a0 := setAccessDbStr(u, "*****", dbPort, dbName)

	db, e2 := sql.Open("mysql", a)
	if e2 != nil {
		log.Printf("Connecting to %q failed: %q", a0, e2)
		return nil, e2
	}

	return db, e2
}
