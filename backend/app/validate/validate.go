package validate

import "gopkg.in/go-playground/validator.v9"

func Validation(s interface{}) error {
	validate := validator.New()
	if err := validate.Struct(s); err != nil {
		return err
	}
	return nil
}
