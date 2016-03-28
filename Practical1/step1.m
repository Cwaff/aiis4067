clear all;
close all;

file_name = 'viptraffic.avi';

file_info = aviinfo(file_name) % returns properties
videoObj = VideoReader(file_name) % returns an object that contains the full video
