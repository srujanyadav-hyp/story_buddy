# AI Story Buddy 🤖📖

A single-screen Flutter app for the Peblo challenge. A buddy named **Pip** reads
a short story aloud, then a quiz appears. Wrong answer shakes, right answer pops
confetti and Pip smiles.

**Flow:** tap *Read Me a Story* → narration → quiz appears → wrong = shake +
buzz → right = confetti + Success.

## How to run

```bash
flutter pub get
flutter run
flutter test
```

## 1. Framework

**Flutter**, so one codebase runs on Android and iOS (Peblo's audience is mostly
Android). State is managed with **Riverpod** — two small state machines, one for
narration and one for the quiz.

## 2. Audio → quiz transition

Narration has clear states: `idle → preparing → playing → finished → error`.
When the TTS engine fires its completion handler, the state becomes `finished`,
and the screen reveals the quiz with a fade + slide animation. It's tied to the
real audio-finished event, not a timer.

## 3. Data-driven quiz

The question comes from [assets/quiz.json](assets/quiz.json), not from code.
`QuizQuestion.fromJson` reads the options as a plain list, and the UI just loops
over them — so 3, 4 or 5 options all work with no code change. Only the JSON
file changes.

## 4. Caching

The quiz JSON is bundled with the app, so it's already on-device (no network).
Native TTS needs no audio file to cache and works offline. If audio were remote
(ElevenLabs bonus), I'd save the synthesized clip to disk keyed on the text +
voice and replay the cached file next time.

## 5. Loading & failure

- **Loading:** the button shows a spinner + "Getting ready…" while audio prepares.
- **Failure:** if TTS fails, a friendly message + **Try Again** button shows.
  The app never hangs or crashes (try/catch + an `error` state).

## 6. Performance

Animations use `AnimationController` + `AnimatedBuilder` with a cached `child`,
so widgets aren't rebuilt 60×/sec. Riverpod `select()` keeps rebuilds small.

_Frame-timing screenshot: [add yours here]_ — capture with `flutter run --profile`
→ DevTools → Performance.

## 7. Lightweight on mid-range Android

- Few packages (riverpod, flutter_tts, confetti, google_fonts).
- Buddy is drawn from shapes, so no image to decode.
- Native TTS, so no audio held in memory; works offline.
- Targeted rebuilds with `select()`.

## 8. AI usage

I used an AI coding assistant correct floder structer and writting test widgets perform
- **Changed its suggestion:** it first revealed the quiz on a fixed timer; I
  replaced that with the TTS completion handler so it matches the real audio end.
- **Didn't work at first:** wiring the TTS handlers on every tap risked duplicate
  calls, so I moved them to run once when the controller is created.

## Structure

```
lib/
├── main.dart
├── models/quiz_question.dart   # data-driven model
├── services/                   # tts + quiz loading
├── state/                      # story + quiz controllers
├── theme/app_theme.dart
├── widgets/                    # buddy, story card, button, quiz, shake
└── screens/story_screen.dart
assets/quiz.json
```
