# MovieBook

Eine moderne Flutter-App für die Verwaltung von Kinobuchungen mit Firebase-Backend.

## Beschreibung

MovieBook ist eine benutzerfreundliche mobile Anwendung, die es Nutzern ermöglicht, ihre Kinobuchungen digital zu verwalten. Die App bietet eine sichere Authentifizierung und eine intuitive Benutzeroberfläche zur Verwaltung persönlicher Buchungsdaten.

## Hauptfunktionen

### Benutzerauthentifizierung
- **Registrierung**: Neue Benutzer können sich mit E-Mail und Passwort registrieren
- **Anmeldung**: Sichere Anmeldung mit Firebase Authentication
- **Personalisierte Daten**: Jeder Benutzer sieht nur seine eigenen Buchungen
- **Automatische Session-Verwaltung**: Benutzer bleiben angemeldet

### Buchungsverwaltung
- **Buchungen erstellen**: Neue Kinobuchungen mit Details hinzufügen
  - Filmtitel (mit Vorschlägen beliebter Filme)
  - Kino-Auswahl (mit lokalen Kinos)
  - Datum und Uhrzeit der Vorstellung
  - Anzahl Sitzplätze
  - Gesamtpreis
- **Buchungen anzeigen**: Übersichtliche Liste aller persönlichen Buchungen
- **Buchungen bearbeiten**: Bestehende Buchungen können angepasst werden
- **Buchungen löschen**: Nicht mehr benötigte Buchungen entfernen
- **Echtzeit-Synchronisation**: Änderungen werden sofort in der Cloud gespeichert

### Erweiterte Features
- **Intelligente Sitzplatzauswahl**: Visueller Sitzplan mit Kategorien (Standard, Premium, VIP)
- **Dynamische Preisberechnung**: Automatische Preisberechnung basierend auf Sitzplatzkategorie
- **Status-Unterscheidung**: Unterscheidung zwischen bevorstehenden und vergangenen Vorstellungen
- **Countdown-Anzeige**: Zeit bis zur Vorstellung wird angezeigt
- **Offline-Unterstützung**: Daten werden lokal zwischengespeichert

## Technische Details

### Technologie-Stack
- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Authentication + Firestore)
- **State Management**: Provider Pattern
- **Plattformen**: Android, iOS, Web

### Architektur
- **Models**: Datenstrukturen für Buchungen
- **Services**: Business Logic und Firebase-Integration
- **Screens**: Benutzeroberflächen und Navigation
- **Widgets**: Wiederverwendbare UI-Komponenten

## Installation & Setup

### Voraussetzungen
```bash

Flutter SDK     ≥ 3.10.0
Dart SDK        ≥ 3.0.0
Android Studio  ≥ 2023.1
Xcode          ≥ 14.0 (nur macOS)
```

### Installation

```bash
# Repository klonen
git clone [repository-url]

# Dependencies installieren
flutter pub get

# App starten
flutter run
```

## Test-Account

Für Testzwecke können Sie folgenden Account verwenden:

**E-Mail**: test@moviebook.ch  
**Passwort**: test123

*Hinweis: Erstellen Sie gerne auch Ihren eigenen Account über die Registrierungsfunktion.*

## Sicherheit

- Firebase Authentication sorgt für sichere Benutzeranmeldung
- Firestore-Sicherheitsregeln gewährleisten Datenschutz
- Jeder Benutzer hat nur Zugriff auf seine eigenen Daten
- Passwörter werden verschlüsselt gespeichert

## Screenshots

### Hauptfunktionen im Überblick
- **Anmeldung**: Sichere Authentifizierung mit Validierung
- **Startseite**: Übersicht aller persönlichen Buchungen
- **Neue Buchung**: Einfaches Formular mit Vorschlägen
- **Sitzplatzauswahl**: Interaktiver Kinoplaner
- **Buchungsdetails**: Detaillierte Ansicht mit Bearbeitungsmöglichkeit

## Zukünftige Erweiterungen

- Push-Benachrichtigungen für Erinnerungen
- Integration mit echten Kino-APIs
- Bezahlfunktion für direkte Buchungen
- Freunde einladen und gemeinsame Buchungen
- Bewertungssystem für Filme
- QR-Code-Generator für Tickets

## Entwicklung

### Projektstruktur
```
lib/
├── models/         # Datenmodelle
├── services/       # Business Logic
├── screens/        # UI-Screens
├── widgets/        # Wiederverwendbare Components
└── utils/          # Hilfsfunktionen
```

### Code-Qualität
- Saubere Architektur mit Trennung der Verantwortlichkeiten
- Umfassende Fehlerbehandlung
- Responsive Design für verschiedene Bildschirmgrößen
- Deutsche Lokalisierung für bessere Benutzerfreundlichkeit

## API-Dokumentation

### Kern-Endpunkte (Firebase Functions - Zukünftige Implementierung)

# Für Produktion erstellen
```bash

POST   /api/v1/bookings              Neue Buchung erstellen
GET    /api/v1/bookings              Benutzer-Buchungen abrufen  
PUT    /api/v1/bookings/{id}         Spezifische Buchung aktualisieren
DELETE /api/v1/bookings/{id}         Buchung entfernen
GET    /api/v1/user/profile          Benutzer-Profildaten
```

## Support

Bei Fragen oder Problemen können Sie gerne ein Issue im Repository erstellen.

---

**MovieBook** - Ihre persönliche Kinobuchungs-App