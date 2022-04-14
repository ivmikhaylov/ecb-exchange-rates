package beAdmin

import (
	"fmt"
)

func callUserCreate(n, h, s string) {

	n = "a_new_username"
	h = "localhost"
	s = "pwd_to_be_hashed"

	q := fmt.Sprintf("CALL run_user_create_query(%q)",
		fmt.Sprintf("%q, %q, ed25519_password(%q)", n, h, s))

	// Dummy for future implementation
	q = q + ""
}
