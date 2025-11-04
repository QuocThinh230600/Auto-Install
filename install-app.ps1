# =============================
# PowerShell App Installer Script
# Author: ChatGPT
# =============================

function Install-List($listName, $items) {
    Write-Host "`n=== Installing $listName ===" -ForegroundColor Cyan
    $installed = (winget list | Select-String "^\S+") -replace '\s.*','' | Sort-Object -Unique

    foreach ($app in $items) {
        $id = $app.Id
        $name = $app.Name

        if ($installed -contains $id) {
            Write-Host "Already installed: $name - skipped." -ForegroundColor DarkGray
            continue
        }

        Write-Host "`nInstalling: $name" -ForegroundColor Yellow
        try {
            winget install --id $id -e --accept-source-agreements --accept-package-agreements -h
            Write-Host "Installed successfully: $name" -ForegroundColor Green
        } catch {
            Write-Host "Error installing: $name" -ForegroundColor Red
        }
    }
}

# =============================
# APP LISTS
# =============================

$chatApps = @(
    @{ Name = "Telegram"; Id = "Telegram.TelegramDesktop" },
    @{ Name = "Zalo"; Id = "VNG.Zalo" },
    @{ Name = "Discord"; Id = "Discord.Discord" }
)

$workApps = @(
    @{ Name = "Visual Studio Code"; Id = "Microsoft.VisualStudioCode" },
    @{ Name = "Visual Studio 2022 Community"; Id = "Microsoft.VisualStudio.2022.Community" },
    @{ Name = "Blender"; Id = "BlenderFoundation.Blender" },
    @{ Name = "OBS Studio"; Id = "OBSProject.OBSStudio" },
    @{ Name = "DaVinci Resolve"; Id = "BlackmagicDesign.DaVinciResolve" },
    @{ Name = "Git"; Id = "Git.Git" },
    @{ Name = "Java JDK (Latest)"; Id = "Oracle.JDK.23" },
    @{ Name = "Notion"; Id = "Notion.Notion" }
)

$gameApps = @(
    @{ Name = "Steam"; Id = "Valve.Steam" },
    @{ Name = "Epic Games Launcher"; Id = "EpicGames.EpicGamesLauncher" },
    @{ Name = "HoYoPlay"; Id = "HoYoverse.HoYoPlay" },
    @{ Name = "Google Play Games"; Id = "Google.PlayGames.Beta" },
    @{ Name = "Moonlight"; Id = "MoonlightGameStreamingProject.Moonlight" },
    @{ Name = "Sunshine"; Id = "LizardByte.Sunshine" },
    @{ Name = "NVIDIA App"; Id = "NVIDIA.App" },
    @{ Name = "MSI Afterburner"; Id = "MSI.Afterburner" },
    @{ Name = "DLSS Wrapper"; Id = "emoose.DLSSWrapper" }
)

$vpnApps = @(
    @{ Name = "Tailscale"; Id = "Tailscale.Tailscale" },
    @{ Name = "Cloudflare 1.1.1.1 (Warp)"; Id = "Cloudflare.Warp" }
)

$utilityApps = @(
    @{ Name = "Google Chrome"; Id = "Google.Chrome" },
    @{ Name = "PowerToys"; Id = "Microsoft.PowerToys" },
    @{ Name = "7-Zip"; Id = "7zip.7zip" },
    @{ Name = "Twinkle Tray"; Id = "xanderfrangos.twinkletray" },
    @{ Name = "Google Quick Share"; Id = "Google.QuickShare" },
    @{ Name = "Sandboxie Plus"; Id = "Sandboxie.Plus" },
    @{ Name = "Fan Control"; Id = "Rem0o.FanControl" },
    @{ Name = "MSEdgeRedirect"; Id = "rcmaehl.MSEdgeRedirect" },
    @{ Name = "Charmy"; Id = "charmyy.tauriapp" },
    @{ Name = "PotPlayer"; Id = "Kakao.PotPlayer" }
)

# =============================
# MAIN MENU LOOP
# =============================
function Show-Menu {
    while ($true) {
        Clear-Host
        Write-Host "=== INSTALLATION MENU ===`n" -ForegroundColor Cyan
        Write-Host "1. Install ALL (Chat + Work + Game + Utilities)"
        Write-Host "2. Install Chat Apps"
        Write-Host "3. Install Work Apps"
        Write-Host "4. Install Game Apps"
        Write-Host "5. Install VPN Apps"
        Write-Host "6. Install Utility Apps"
        Write-Host "9. Choose manually"
        Write-Host "0. Exit"
        Write-Host ""

        $choice = Read-Host "Enter your choice (0-6)"

        switch ($choice) {
            "1" {
                Install-List "Chat Apps" $chatApps
                Install-List "Work Apps" $workApps
                Install-List "Game Apps" $gameApps
                Install-List "Utility Apps" $vpnApps
                Install-List "Utility Apps" $utilityApps
            }
            "2" { Install-List "Chat Apps" $chatApps }
            "3" { Install-List "Work Apps" $workApps }
            "4" { Install-List "Game Apps" $gameApps }
            "5" { Install-List "VPN Apps" $vpnApps }
            "6" { Install-List "Utility Apps" $utilityApps }
            "9" {
                $allApps = @()
                $index = 1

                Write-Host "`n--- CHAT APPS ---" -ForegroundColor Cyan
                foreach ($app in $chatApps) {
                    Write-Host ("{0}. {1}" -f $index, $app.Name)
                    $index++
                    $allApps += $app
                }

                Write-Host "`n--- WORK APPS ---" -ForegroundColor Cyan
                foreach ($app in $workApps) {
                    Write-Host ("{0}. {1}" -f $index, $app.Name)
                    $index++
                    $allApps += $app
                }

                Write-Host "`n--- GAME APPS ---" -ForegroundColor Cyan
                foreach ($app in $gameApps) {
                    Write-Host ("{0}. {1}" -f $index, $app.Name)
                    $index++
                    $allApps += $app
                }

                Write-Host "`n--- VPN APPS ---" -ForegroundColor Cyan
                foreach ($app in $vpnApps) {
                    Write-Host ("{0}. {1}" -f $index, $app.Name)
                    $index++
                    $allApps += $app
                }

                Write-Host "`n--- UTILITIES ---" -ForegroundColor Cyan
                foreach ($app in $utilityApps) {
                    Write-Host ("{0}. {1}" -f $index, $app.Name)
                    $index++
                    $allApps += $app
                }

                Write-Host ""
                $selection = Read-Host "Enter numbers separated by commas (example: 1,3,7)"

                if (-not $selection) {
                    Write-Host "`nNo apps selected. Returning to main menu..." -ForegroundColor Red
                    Start-Sleep 2
                    continue
                }

                $selectedIndexes = $selection -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -match "^\d+$" }
                $selectedApps = @()

                foreach ($i in $selectedIndexes) {
                    if ($i -le $allApps.Count) {
                        $selectedApps += $allApps[$i - 1]
                    }
                }

                if ($selectedApps.Count -eq 0) {
                    Write-Host "`nNo valid apps selected. Returning to main menu..." -ForegroundColor Red
                    Start-Sleep 2
                    continue
                }

                Install-List "Selected Apps" $selectedApps
            }
            "0" {
                Write-Host "`nExiting script. Goodbye!" -ForegroundColor Yellow
                exit
            }
            Default {
                Write-Host "`nInvalid choice. Please try again." -ForegroundColor Red
                Start-Sleep 2
                continue
            }
        }

        Write-Host "`nAll installations completed or skipped!" -ForegroundColor Green
        Write-Host "Press any key to return to menu..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}

Show-Menu
