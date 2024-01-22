function save_log()
t = datetime('now','TimeZone','Asia/Tokyo','Format','uuuu-MM-dd''T''HH-mm-ss');
save("./LOG/" + string(t) + ".mat");
end