function particles = predict_particles(particles,u)
    for i = 1:ParticlesNum
        px = zeros(STATE_SIZE,1);
        px[0, 0] = particles[i].x
        px[1, 0] = particles[i].y
        px[2, 0] = particles[i].yaw
        ud = u + (np.random.randn(1, 2).* R)*T;
        px = motion_model(px, ud)
        particles[i].x = px[0, 0]
        particles[i].y = px[1, 0]
        particles[i].yaw = px[2, 0]
    end
    
end