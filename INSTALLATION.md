# Installation Guide

## Quick Start

### 1. Install the Package

```bash
# Install globally (recommended)
dart pub global activate ai_localizer

# Or install locally in your project
dart pub add ai_localizer
```

### 2. Set Up Your API Key

Create a `.env` file in your project root:

```env
GEMINI_API_KEY=your_gemini_api_key_here
```

**Get your API key from:** <https://aistudio.google.com/app/apikey>

### 3. Test the Installation

```bash
# Test the help command
ai_localizer --help

# Or if installed locally
dart run ai_localizer --help
```

## Detailed Installation

### Prerequisites

- **Dart SDK**: Version 3.0.0 or higher
- **API Key**: Gemini, OpenAI, or DeepSeek API key

### Global Installation (Recommended)

This allows you to use the tool from anywhere on your system:

```bash
dart pub global activate ai_localizer
```

After installation, you can use the command directly:

```bash
ai_localizer -i lib/l10n/app_en.arb -l fr,de,es
```

### Local Installation

Add the package to your project's dependencies:

```bash
dart pub add ai_localizer
```

Then run it using:

```bash
dart run ai_localizer -i lib/l10n/app_en.arb -l fr,de,es
```

### Development Installation

For development or testing:

```bash
git clone https://github.com/yourusername/ai_localizer.git
cd ai_localizer
dart pub get
dart run bin/ai_localizer.dart --help
```

## API Key Setup

### Option 1: Environment File (Recommended)

Create a `.env` file in your project root:

```env
# For Gemini 2.0 Flash (default)
GEMINI_API_KEY=your_gemini_api_key_here

# For OpenAI GPT-3.5 Turbo
OPENAI_API_KEY=your_openai_api_key_here

# For DeepSeek
DEEPSEEK_API_KEY=your_deepseek_api_key_here
```

### Option 2: Environment Variables

Set the environment variable directly:

```bash
# macOS/Linux
export GEMINI_API_KEY=your_gemini_api_key_here

# Windows (Command Prompt)
set GEMINI_API_KEY=your_gemini_api_key_here

# Windows (PowerShell)
$env:GEMINI_API_KEY="your_gemini_api_key_here"
```

### Option 3: System-wide Environment

Add to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
export GEMINI_API_KEY=your_gemini_api_key_here
```

## Getting API Keys

### Gemini API Key

1. Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy the generated key

### OpenAI API Key

1. Visit [OpenAI Platform](https://platform.openai.com/api-keys)
2. Sign in to your account
3. Click "Create new secret key"
4. Copy the generated key

### DeepSeek API Key

1. Visit [DeepSeek Platform](https://platform.deepseek.com/)
2. Sign in to your account
3. Navigate to API keys section
4. Create a new API key

## Verification

After installation, verify everything is working:

```bash
# Test the help command
ai_localizer --help

# Test with a sample file
echo '{"hello": "Hello, World!"}' > test.arb
ai_localizer -i test.arb -l fr -v
```

## Troubleshooting

### "Command not found" Error

If you get a "command not found" error after global installation:

1. **Check your PATH**: Make sure `$HOME/.pub-cache/bin` is in your PATH
2. **Restart your terminal**: Close and reopen your terminal
3. **Add to PATH manually**:

```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### API Key Not Found

If you get "GEMINI_API_KEY is not set":

1. **Check your `.env` file**: Make sure it exists and has the correct format
2. **Check environment variables**: Run `echo $GEMINI_API_KEY` to verify
3. **Restart your terminal**: Environment changes may require a restart

### Permission Denied

If you get permission errors:

```bash
# Make sure the script is executable
chmod +x scripts/release.sh

# Or run with sudo if needed
sudo dart pub global activate ai_localizer
```

## Next Steps

Once installed, check out the [README.md](README.md) for usage examples and advanced features.
