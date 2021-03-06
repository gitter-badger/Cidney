﻿function Get-ThrottleLimit
{
    $property = 'numberOfCores', 'NumberOfLogicalProcessors'
    $cpuInfo = Get-WmiObject -class win32_processor -Property $property | Select-Object -Property $property
    $suggestedThreads = ($cpuInfo.numberOfLogicalProcessors * $cpuInfo.NumberOfCores)
    $throttle = [int32]$suggestedThreads;

    return $throttle
}
