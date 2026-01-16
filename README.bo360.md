# BO360 Operations Command Console - Planka Fork

This is a customized fork of [Planka](https://github.com/plankanban/planka) with the **BO360 Operations Command Console** theme applied at the source level.

## Overview

The BO360 theme transforms Planka's default appearance into a modern, dark-mode "cyber ops" console with:

- **Dark glassmorphic surfaces** with blur effects
- **Cyan accent colors** (#00d4ff) for interactive elements
- **Neon glow effects** on hover states
- **Condensed density** for efficient information display
- **Consistent design tokens** across all components

## Theme Colors

| Token | Color | Usage |
|-------|-------|-------|
| `$bo360-bg-primary` | #0a0e14 | Main background |
| `$bo360-bg-secondary` | #111821 | Cards, modals background |
| `$bo360-bg-tertiary` | #1a2332 | Headers, elevated surfaces |
| `$bo360-bg-elevated` | #1e2738 | Card hover states |
| `$bo360-accent-primary` | #00d4ff | Primary accent (cyan) |
| `$bo360-accent-secondary` | #00ff88 | Success states (green) |
| `$bo360-accent-warning` | #ffaa00 | Warning states (orange) |
| `$bo360-accent-danger` | #ff3366 | Error/danger states (red) |
| `$bo360-text-primary` | #e8eef5 | Primary text |
| `$bo360-text-secondary` | #8899aa | Secondary text |
| `$bo360-text-muted` | #556677 | Muted/disabled text |

## Modified Files

### Theme Variables
- `client/src/styles/_bo360-variables.scss` - Central theme design tokens

### Styled Components
- `client/src/styles.module.scss` - Global styles, scrollbars
- `client/src/components/common/Header/Header.module.scss` - Top navigation bar
- `client/src/components/lists/List/List.module.scss` - Kanban lists
- `client/src/components/cards/Card/Card.module.scss` - Card styling
- `client/src/components/cards/CardModal/CardModal.module.scss` - Card detail modal
- `client/src/components/common/Login/Content.module.scss` - Login page
- `client/src/components/boards/Board/KanbanContent/KanbanContent.module.scss` - Board canvas

## Quick Start

### Local Development

1. **Build and run locally:**
   ```bash
   cd tools/planka-fork
   docker-compose -f docker-compose.bo360.yml up -d
   ```

2. **Access Planka:**
   Open http://localhost:3000

3. **Default credentials:**
   - Email: `admin@bo360.local`
   - Password: `changeme123`

### Production Deployment

Use the deployment script:

```bash
./ops/planka/deploy.sh
```

Or manually:

```bash
cd tools/planka-fork

# Build the image
docker build -t planka-bo360:latest .

# Deploy
docker-compose -f docker-compose.bo360.yml up -d
```

## Updating from Upstream

To pull updates from the original Planka repository:

```bash
cd tools/planka-fork

# Add upstream remote (only needed once)
git remote add upstream https://github.com/plankanban/planka.git

# Fetch upstream changes
git fetch upstream

# Merge upstream changes into your branch
git merge upstream/master

# Resolve any conflicts in the themed SCSS files
# The BO360 changes are isolated to the files listed above
```

### Conflict Resolution Tips

When merging upstream changes, conflicts will likely occur in the styled files. To resolve:

1. Keep the `@import '../../../styles/bo360-variables';` at the top of each file
2. Apply BO360 color variables to any new styles added by upstream
3. Preserve the mixin usage (`@include bo360-glass-surface`, etc.)
4. Test the build after resolving: `docker build -t planka-bo360:latest .`

## Docker Commands

```bash
# Build image
docker build -t planka-bo360:latest .

# Start services
docker-compose -f docker-compose.bo360.yml up -d

# View logs
docker-compose -f docker-compose.bo360.yml logs -f planka

# Stop services
docker-compose -f docker-compose.bo360.yml down

# Rebuild and restart
docker-compose -f docker-compose.bo360.yml up -d --build

# View container status
docker ps | grep planka-bo360
```

## Environment Variables

Create a `.env` file with:

```env
# Required in production
BASE_URL=https://planka.eroland.me
SECRET_KEY=your-secure-random-key-here

# Optional admin setup
DEFAULT_ADMIN_EMAIL=admin@example.com
DEFAULT_ADMIN_PASSWORD=secure-password
DEFAULT_ADMIN_NAME=Admin User
DEFAULT_ADMIN_USERNAME=admin

# Email (optional)
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=user@example.com
SMTP_PASSWORD=password
SMTP_FROM="Planka" <noreply@example.com>
```

## File Structure

```
tools/planka-fork/
├── client/
│   └── src/
│       ├── styles/
│       │   └── _bo360-variables.scss    # Theme variables
│       ├── styles.module.scss           # Global styles
│       └── components/
│           ├── common/
│           │   ├── Header/
│           │   │   └── Header.module.scss
│           │   └── Login/
│           │       └── Content.module.scss
│           ├── boards/
│           │   └── Board/
│           │       └── KanbanContent/
│           │           └── KanbanContent.module.scss
│           ├── lists/
│           │   └── List/
│           │       └── List.module.scss
│           └── cards/
│               ├── Card/
│               │   └── Card.module.scss
│               └── CardModal/
│                   └── CardModal.module.scss
├── Dockerfile                           # Custom build with BO360 labels
├── docker-compose.bo360.yml             # BO360-specific compose file
└── README.bo360.md                      # This file
```

## Related Resources

- [Original Planka Repository](https://github.com/plankanban/planka)
- [Planka Documentation](https://docs.planka.cloud/)
- [BO360 Theme CSS (injection version)](../../.codebase_folder_reorg/apps/web/public/bo360-theme.css)
- [Deployment Script](../../ops/planka/deploy.sh)

## License

This fork inherits the [Fair Use License](LICENSE.md) from the original Planka project.

BO360 theme customizations are provided as part of the Benefits Outreach 360 project.
