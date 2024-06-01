package main

import (
	"bufio"
	"fmt"
	"strconv"

	//"reflect"
	"database/sql"
	"log"
	"net/http"
	"os"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
    db, err := sql.Open("mysql", "nikita:5463@/observatory")
     
    if err != nil {
        panic(err)
    } 
    defer db.Close()
	
	// открытие из браузера корневого каталога.
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request){
	
		viewSelect(w, db)
    })

	// сохранение отправленных значений через поля формы.
	http.HandleFunc("/postform", func(w http.ResponseWriter, r *http.Request){

		objType := r.FormValue("type")
		accuracy := r.FormValue("accuracy")
		quantity := r.FormValue("quantity")
		time := r.FormValue("time")
		date := r.FormValue("date")
		notes := r.FormValue("notes")

		sQuery := "INSERT INTO objects (type, accuracy, quantity, time, date, notes) VALUES (?, ?, ?, ?, ?, ?)"

		fmt.Println(sQuery)

		rows, err := db.Query(sQuery, objType, accuracy, quantity, time, date, notes)
 
		if err != nil {
			panic(err)
		}		
		defer rows.Close()
		
		viewSelect(w, db)
    })
	

    fmt.Println("Server is listening on http://localhost:8181/")
    http.ListenAndServe(":8181", nil)	
}


// отправка в браузер заголовка таблицы.
func viewHeadQuery(w http.ResponseWriter, db *sql.DB, sShow string) {
	type sHead struct {
		clnme string
	}
    rows, err := db.Query(sShow)
    if err != nil {
        panic(err)
    }
    defer rows.Close()

	fmt.Fprintf(w, "<tr>")
     for i := 0; i < 7; i++ {
		rows.Next()
        p := sHead{}
        err := rows.Scan(&p.clnme)
        if err != nil{
            fmt.Println(err)
            continue
        }
		fmt.Fprintf(w, "<td>"+p.clnme+"</td>")
    }
	fmt.Fprintf(w, "</tr>")
}

func mapObjectType(objType string) string {	
	var objTypeMap = map[string]string{
		"planet": "Планета",
		"star": "Звезда",
		"satellite": "Спутник",
		"asteroid": "Астероид",
		"comet": "Комета",
		"meteorite": "Метеорит",
	}

	return objTypeMap[objType]
}

// отправка в браузер строк из таблицы.
func viewSelectQuery(w http.ResponseWriter, db *sql.DB, sSelect string) {
	type object struct {
		id int
		objType string
		accuracy string
		quantity string
		time string
		date string
		notes string
	}
	objects := []object{}

	// получение значений в массив tests из струкрур типа test.
    rows, err := db.Query(sSelect)
    if err != nil {
        panic(err)
    }
    defer rows.Close()
     
    for rows.Next() {
        p := object{}
        err := rows.Scan(&p.id, &p.objType, &p.accuracy, &p.quantity, &p.time, &p.date, &p.notes)
        if err != nil{
            fmt.Println(err)
            continue
        }
        objects = append(objects, p)
    }
	
	// перебор массива из БД.
	for _, p := range objects {
		fmt.Fprintf(w, "<tr><td>"+strconv.Itoa(p.id)+"</td><td>"+mapObjectType(p.objType)+"</td><td>"+p.accuracy+"</td><td>"+p.quantity+"</td><td>"+p.time+"</td><td>"+p.date+"</td><td>"+p.notes+"</td></tr>")
	}
}
	
// отправка в браузер версии базы данных.
func viewSelectVerQuery (w http.ResponseWriter, db *sql.DB, sSelect string) {
	type sVer struct {
		ver string
	}
    rows, err := db.Query(sSelect)
    if err != nil {
        panic(err)
    }
    defer rows.Close()
     for rows.Next() {
        p := sVer{}
        err := rows.Scan(&p.ver)
        if err != nil{
            fmt.Println(err)
            continue
        }
		fmt.Fprintf(w, p.ver)
    }
}

// главная функция для показа таблицы в браузере, которая показывается при любом запросе.
func viewSelect(w http.ResponseWriter, db *sql.DB) {

	// чтение шаблона.
	file, err := os.Open("select.html")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		//	кодовая фраза для вставки значений из БД.
		if scanner.Text() != "@tr" && scanner.Text() != "@ver" {
			fmt.Fprintf(w, scanner.Text())
		}
		if scanner.Text() == "@tr" {
			viewHeadQuery(w, db, "select COLUMN_NAME AS clnme from information_schema.COLUMNS where TABLE_NAME='objects' ORDER BY ORDINAL_POSITION")
			viewSelectQuery(w, db, "CALL select_objects()")
		}
		if scanner.Text() == "@ver" {
			viewSelectVerQuery(w, db, "SELECT VERSION() AS ver")
		}
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}

