# PowerShell script: dev.ps1

# Function to check SSO session and login if needed
function Ensure-SSOSession {
    Write-Host "Checking SSO session..."
    
    # Capture both output and error streams, and check exit code
    $output = aws sts get-caller-identity --profile Darren-Jackson 2>&1
    $exitCode = $LASTEXITCODE
    
    # Check if the command succeeded and didn't contain error messages
    if ($exitCode -eq 0 -and $output -notmatch "Error when retrieving token" -and $output -notmatch "Token has expired") {
        Write-Host "SSO session is valid"
        return $true
    }
    else {
        Write-Host "SSO session expired or invalid. Error details:"
        Write-Host $output
        Write-Host "Initiating login..."
        
        try {
            aws sso login --profile Darren-Jackson
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Successfully authenticated with SSO"
                # Verify the session is now working
                $verifyOutput = aws sts get-caller-identity --profile Darren-Jackson 2>&1
                if ($LASTEXITCODE -eq 0 -and $verifyOutput -notmatch "Error when retrieving token") {
                    Write-Host "SSO session verification successful"
                    return $true
                }
                else {
                    Write-Host "SSO session verification failed after login"
                    return $false
                }
            }
            else {
                Write-Host "SSO login failed"
                return $false
            }
        }
        catch {
            Write-Host "Error during SSO login: $_"
            return $false
        }
    }
}

# Ensure we have a valid SSO session
if (-not (Ensure-SSOSession)) {
    Write-Host "Failed to establish SSO session. Exiting..."
    exit 1
}

Write-Host "Fetching secrets from AWS..."

# Get secret from AWS and convert to environment variables
try {
    $secretJson = aws secretsmanager get-secret-value `
        --profile Darren-Jackson `
        --secret-id publish_to_pypi `
        --query SecretString `
        --output text | ConvertFrom-Json

    $secretJson.PSObject.Properties | ForEach-Object {
        [System.Environment]::SetEnvironmentVariable($_.Name, $_.Value, 'Process')
    }
    
    # Output the TESTPYPI_API_KEY for batch script to capture
    if ($secretJson.TESTPYPI_API_KEY) {
        "TESTPYPI_API_KEY=$($secretJson.TESTPYPI_API_KEY)"
        Write-Host "TESTPYPI_API_KEY retrieved successfully."
    } else {
        Write-Host "ERROR: TESTPYPI_API_KEY not found in secrets"
        exit 1
    }
    if ($secretJson.PYPI_API_KEY) {
        "PYPI_API_KEY=$($secretJson.PYPI_API_KEY)"
        Write-Host "PYPI_API_KEY retrieved successfully."
    } else {
        Write-Host "ERROR: PYPI_API_KEY not found in secrets"
        exit 1
    }
}
catch {
    Write-Host "Error fetching secrets: $_"
    exit 1
}

Write-Host "AWS Auth complete."