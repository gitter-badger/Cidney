﻿function Initialize-CidneyVariables
{
     param
     (
         [scriptblock]
         $ScriptBlock,
         [string]
         $Scope = 'Global'
     )

    $context = Get-CidneyContext
    if (-not $context.Contains("$($Scope)Variables"))
    {
        $context.Add("$($Scope)Variables", @())
    }
    
    if ($ScriptBlock.ToString().Trim())
    {
        $newVariables = @()
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($ScriptBlock.ToString(), [ref] $null, [ref] $null);

        $assignments = $AST.FindAll({$args[0] -is [System.Management.Automation.Language.AssignmentStatementAst]}, $false) 
        foreach($assignment in $assignments)
        {
            $item = $assignment
            $name = $item.Left.VariablePath.UserPath
            $value = Invoke-Expression -Command $item.Right.Expression

            if (-not (Get-Variable -Name $name -Scope $Scope -ErrorAction SilentlyContinue))
            {
                New-Variable -Name $name -Value $value -Scope $Scope -Force -ErrorAction SilentlyContinue
                $newVariables += Get-Variable -Name $name -Scope $Scope              
            }
            else
            {
                Set-Variable -Name $name -Value $value -Scope $Scope -Force -ErrorAction SilentlyContinue
            }                 
        } 

        if ($newVariables.Count -gt 0)
        {
            $context["$($Scope)Variables"] += $newVariables              
        }
    }
}