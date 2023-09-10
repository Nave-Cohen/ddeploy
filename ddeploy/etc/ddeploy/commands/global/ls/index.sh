#!/usr/bin/env bash

import "status"

folders=$(getAll "folder")
projectStatus "$folders"
