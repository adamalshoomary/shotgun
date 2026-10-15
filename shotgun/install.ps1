# Installs the shotgun skill for every coding agent on this computer that reads Agent Skills.
#
#   powershell -NoProfile -Command "irm https://github.com/adamalshoomary/shotgun/releases/latest/download/install.ps1 | iex"
#
# The skill needs its whole folder: SKILL.md, VERSION, five guides and templates\.
# Claude Code reads ~\.claude\skills. Codex, Gemini CLI, Cursor and most other agents read ~\.agents\skills.
# A release holds its files flat. SHOTGUN_FROM sets another address for them; CI uses it to test a build.
# Keep the file list in step with install.sh and tools/release_files.py.
# Keep this file ASCII: irm reads it as text without a character set.
$ErrorActionPreference = 'Stop'
$From = 'https://github.com/adamalshoomary/shotgun/releases/latest/download'
if ($env:SHOTGUN_FROM) { $From = $env:SHOTGUN_FROM.TrimEnd('/') }
# A release cannot hold a file whose name starts with a dot, so .gitignore.template travels as gitignore.template.
$Files = [ordered]@{
    'SKILL.md' = 'SKILL.md'; 'VERSION' = 'VERSION'; 'SETUP.md' = 'SETUP.md'; 'CONTINUE.md' = 'CONTINUE.md'
    'LEARNING.md' = 'LEARNING.md'; 'ORCHESTRATION.md' = 'ORCHESTRATION.md'; 'MIGRATIONS.md' = 'MIGRATIONS.md'
    'AGENTS.md.template' = 'templates\AGENTS.md.template'
    'current-state.md.template' = 'templates\current-state.md.template'
    'improvement-plan.md.template' = 'templates\improvement-plan.md.template'
    'project-purpose.md.template' = 'templates\project-purpose.md.template'
    'gitignore.template' = 'templates\.gitignore.template'
}
$Tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("shotgun-" + [guid]::NewGuid())
New-Item -ItemType Directory -Path (Join-Path $Tmp 'templates') | Out-Null
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    foreach ($Name in $Files.Keys) {
        try { Invoke-WebRequest -UseBasicParsing -Uri "$From/$Name" -OutFile (Join-Path $Tmp $Files[$Name]) }
        catch { throw "shotgun: could not download $Name from $From. Try again, or install with: npx skills add adamalshoomary/shotgun -g" }
    }
    # Versions before 4.0.0 installed as "handoff". Remove that copy only when it is shotgun's own.
    foreach ($Old in @((Join-Path $HOME '.claude\skills\handoff'), (Join-Path $HOME '.agents\skills\handoff'))) {
        $Skill = Join-Path $Old 'SKILL.md'
        if ((Test-Path $Skill) -and (Select-String -Path $Skill -Pattern 'shotgun' -Quiet) -and (Select-String -Path $Skill -Pattern '^name: handoff' -Quiet)) {
            Remove-Item -Recurse -Force $Old
            Write-Host "removed the old handoff skill: $Old"
        }
    }
    foreach ($Dest in @((Join-Path $HOME '.claude\skills\shotgun'), (Join-Path $HOME '.agents\skills\shotgun'))) {
        if (Test-Path $Dest) { Remove-Item -Recurse -Force $Dest }
        New-Item -ItemType Directory -Force -Path (Join-Path $Dest 'templates') | Out-Null
        foreach ($Rel in $Files.Values) { Copy-Item -LiteralPath (Join-Path $Tmp $Rel) -Destination (Join-Path $Dest $Rel) -Force }
        Write-Host "installed: $Dest"
    }
    $Version = (Get-Content (Join-Path $Tmp 'VERSION') -TotalCount 1).Split(' ')[0]
    Write-Host "shotgun $Version is ready. Restart your agent, open your project folder and run: /shotgun setup"
}
finally {
    Remove-Item -Recurse -Force $Tmp -ErrorAction SilentlyContinue
}
