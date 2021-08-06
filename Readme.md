# Zbieranie IOPS z vCenter/ESX w czasie rzeczywistym

## OPIS

Jest to krótki skrypt, pobierający z vCenter lub ESX dane statystyczne dotyczące sumarycznego IOPS (dla wszystkich wirtualnych dysków) danej maszyny wirtualnej. Pobrane dane zapisywane są w pliku csv.

## **JAK URUCHOMIĆ**

1. W skrypcie uzupełnij zmienne:

   - `$vcenterIp` - adres IP/nazwa vCenter lub ESX
   - `$userName` - nazwa użytkownika z uprawnieniami do czytania statystyk
   - `$consoleOut` - pisanie na konsolę zczytanych IOPS (true/false)
   - `$samples` - ilość próbek (zbierane domyślnie co 20 sek)

2. Uruchom skrypt

   - `./Collect-Iops.ps1 -vmName my-vm`
   - Zostaniemy zapytani o hasło dla zdefiniowanego wcześniej użytkownika

## OGRANICZENIA

- VM musi być właczona (PoweredOn)
- Skrypt nie działa jako daemon

## **KONTAKT**

E-mail: [krzysztof@nowoczesnysieciowiec.pl](mailto:krzysztof@nowoczesnysieciowiec.pl?Subject=Projekt%20VagrantAnsibleSetup)

## **LICENCJA**

Autor dołożył wszelkich starań, aby zawarte tu informacje były rzetelne, ale nie gwarantuje ich poprawności. Autor nie bierze odpowiedzialności za żadne szkody wynikające z wykorzystania zawartych tu informacji i skryptów.

Pliki zawarte w tym projekcie mogą być swobodnie wykorzystywane. Mogą one być też dowolnie modyfikowane, z zachowaniem informacji o źródle.

Kopiowanie i dystrybucja możliwa jest tylko z zachowaniem informacji o źródle.

Zawarte w tym projekcie nazwy produktów i znaki towarowe należą do ich prawowitych właścicieli

(C) [Nowoczesny Sieciowiec](https://nowoczesnysieciowiec.pl "Blog Nowoczesny Sieciowiec"), 2021
