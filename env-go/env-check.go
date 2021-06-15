package kubeless 

import (
	"fmt"
	"os"
	"log"
	"github.com/kubeless/kubeless/pkg/functions"
)


func Foo(event functions.Event, context functions.Context) (string, error) {
	envVariable := event.Data
	log.Printf("Reading ENV for varaible - %v", envVariable)
	envVar := os.Getenv(envVariable)
	if envVar == "" {
	         return	fmt.Sprintf("Coudln't get the %v from env varibale", envVariable), nil
	}
	log.Printf(envVar)
	return fmt.Sprintf("Value of ENV Var %v is %v",envVariable,envVar ), nil
}

